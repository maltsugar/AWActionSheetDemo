

Pod::Spec.new do |spec|

  spec.name         = "AWActionSheet"
  spec.version      = "1.0.3"
  spec.summary      = "A custom actionSheet. 一款自定义 ActionSheet."
  spec.description  = <<-DESC
                    Support for custom view, custom viewcontroller, as content display. Customized a sharing view in the demo.
                    支持将自定义view，自定义viewcontroller，作为content显示。 demo里自定义了一款分享视图
                   DESC
  spec.homepage     = "https://github.com/maltsugar/AWActionSheetDemo"
  spec.license      = { :type => "MIT", :file => "LICENSE" }



  spec.author             = { "zgy" => "173678978@qq.com" }
  # Or just: spec.author    = "zgy"
  # spec.authors            = { "zgy" => "173678978@qq.com" }
  # spec.social_media_url   = "https://twitter.com/zgy"

  spec.platform     = :ios, "8.0"


  spec.source       = { :git => "https://github.com/maltsugar/AWActionSheetDemo.git", :tag => "#{spec.version}" }


  spec.source_files  = "AWActionSheetDemo/AWActionSheet/*.{h,m}"
  spec.resource_bundles = {
  'AWActionSheet' => ['AWActionSheetDemo/AWActionSheet/*.{xib}']
}

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
