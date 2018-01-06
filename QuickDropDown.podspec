Pod::Spec.new do |s|
    s.name             = "QuickDropDown"
    s.version          = "1.0.0"
    s.summary          = "一款简洁大方的下拉列表框控件。"
    s.description      = <<-DESC
    一款简洁大方的下拉列表框控件。
    DESC
    s.homepage         = "https://github.com/pcjbird/QuickDropDown"
    s.license          = 'MIT'
    s.author           = {"pcjbird" => "pcjbird@hotmail.com"}
    s.source           = {:git => "https://github.com/pcjbird/QuickDropDown.git", :tag => s.version.to_s}
    s.social_media_url = 'http://www.lessney.com'
    s.requires_arc     = true
    #s.documentation_url = ''
    #s.screenshot       = ''

    s.platform         = :ios, '8.0'
    s.frameworks       = 'Foundation', 'UIKit'
    #s.preserve_paths   = ''
    s.source_files     = 'QuickDropDown/*.{h,m}','QuickDropDown/QuickDropDownDefines/*.{h,m}'
    s.public_header_files = 'QuickDropDown/*.{h}'


    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

end

