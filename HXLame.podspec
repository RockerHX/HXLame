#
# Be sure to run `pod lib lint HXLame.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'HXLame'
    s.version          = '0.1.0'
    s.summary          = 'HXLame is iOS library build on PCM to Mp3 library - lame.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
HXLame is iOS library build on PCM to Mp3 library - lame. It can easy to take PCM convert to Mp3 with swift.
                       DESC

    s.homepage         = 'https://github.com/RockerHX/HXLame'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'rockerhx@gmail.com' => 'rockerhx@gmail.com' }
    s.source           = { :git => 'https://github.com/rockerhx@gmail.com/HXLame.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '8.0'

    s.source_files = 'HXLame/Classes/**/*'
    s.prepare_command = <<-EOF
        # 创建Module
        rm -rf HXLame/Frameworks/lame.framework/Modules
        mkdir HXLame/Frameworks/lame.framework/Modules
        touch HXLame/Frameworks/lame.framework/Modules/module.modulemap
        cat <<-EOF > HXLame/Frameworks/lame.framework/Modules/module.modulemap
        framework module lame {
        umbrella header "lame.h"

        export *
        module * { export * }
        }
        \EOF

    EOF

  
    # s.resource_bundles = {
    #   'HXLame' => ['HXLame/Assets/*.png']
    # }

    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'

        s.subspec 'lame' do |ss|
        ss.source_files = 'HXLame/Frameworks/*.framework/Headers/**.h'
        ss.public_header_files = 'HXLame/Frameworks/*.framework/Headers/**.h'

        ss.vendored_frameworks =  'HXLame/Frameworks/*.framework'

        ss.preserve_paths = 'HXLame/Frameworks/*.framework'
        ss.pod_target_xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '$(PODS_ROOT)/HXLame/Frameworks/' }
        end

end
