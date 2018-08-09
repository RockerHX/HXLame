//
//  HXLame.swift
//  HXLame
//
//  Created by RockerHX on 2018/8/9.
//


import Foundation


public class HXLame {

    public static func coverToMp3(with pcmURL:URL, writeTo url: URL, completion: ((_ mp3URL: URL) -> Void)?) {
        var read: Int32 = 0, write: Int32 = 0
        guard let pcm = fopen(pcmURL.absoluteString.cString(using: .utf8), "rb") else { return}
        fseek(pcm, 4*1024, SEEK_CUR)
        guard let mp3 = fopen(url.absoluteString.cString(using: .utf8), "wb+") else { return }
        let PCM_SIZE = 1024*8
        let MP3_SIZE: Int32 = 1024*8
        var pcm_buffer = Array<Int16>(repeating: 0, count: PCM_SIZE*2)
        var mp3_buffer = Array<UInt8>(repeating: 0, count: Int(MP3_SIZE))

//        let lame = lame_init()
//        lame_set_num_channels(lame, 1)
//        lame_set_in_samplerate(lame, 44100)
//        lame_set_VBR(lame, vbr_default)
//        lame_init_params(lame)

//        let lame = lame_init()
//        lame_set_num_channels(lame, 1)          // 单声道
//        lame_set_in_samplerate(lame, 16000)     // 16K采样率
//        lame_set_VBR(lame, vbr_default)
//        lame_set_brate(lame, 128)               // 压缩的比特率为128K
//        lame_set_mode(lame, MPEG_mode(rawValue: 1))
//        lame_set_quality(lame, 2)
//        lame_init_params(lame)


        /*这边设置的参数需要与录音时设置的参数做对照，否则压缩会出现问题
         asbd.mSampleRate = 8000;            //采样率
         asbd.mFormatID = kAudioFormatLinearPCM;
         asbd.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
         asbd.mChannelsPerFrame = 1;         //单声道
         asbd.mFramesPerPacket = 1;          //每一个packet一侦数据
         asbd.mBitsPerChannel = 16;          //每个采样点16bit量化
         asbd.mBytesPerFrame = (asbd.mBitsPerChannel / 8) * asbd.mChannelsPerFrame;
         asbd.mBytesPerPacket = asbd.mBytesPerFrame ;
         */
        let lame = lame_init()
        lame_set_num_channels(lame, 1)              // 单声道
        //!!!:经过测试，这里设置采样率为录音时的采样率的一半为最佳音效
        lame_set_in_samplerate(lame, 44100)         // 采样率
        lame_set_VBR(lame, vbr_off)
        lame_set_brate(lame, 32)                    // 压缩的比特率为16K
        lame_set_mode(lame, STEREO)                 // 四种类型的声道
        lame_set_quality(lame, 5)                   // 2=high 5 = medium 7=low 音 质
        lame_mp3_tags_fid(lame, mp3)
        lame_init_params(lame)


        DispatchQueue.global().async {
            repeat {
                read = Int32(fread(&pcm_buffer, MemoryLayout<Int16>.size*2, PCM_SIZE, pcm))
                if 0 == read {
                    write = lame_encode_flush(lame, &mp3_buffer, MP3_SIZE)
                } else {
                    write = lame_encode_buffer_interleaved(lame, &pcm_buffer, read, &mp3_buffer, MP3_SIZE)
                }
                fwrite(&mp3_buffer, Int(write), 1, mp3)
            } while read != 0
            
            lame_mp3_tags_fid(lame, mp3)
            lame_close(lame)
            fclose(mp3)
            fclose(pcm)

            DispatchQueue.main.async {
                completion?(url)
            }
        }
    }

}

