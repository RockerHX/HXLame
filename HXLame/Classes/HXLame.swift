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

        let lame = lame_init()
        lame_set_num_channels(lame, 1)
        lame_set_in_samplerate(lame, 44100)
        lame_set_VBR(lame, vbr_default)
        lame_set_brate(lame, 16)
        lame_set_mode(lame, JOINT_STEREO)
        lame_set_quality(lame, 2)                   // 2 = high 5 = medium 7 = low
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

