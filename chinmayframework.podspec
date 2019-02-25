

Pod::Spec.new do |s|
  s.name             = 'chinmayframework'
  s.version          = '0.1.2'
  s.summary          = 'This is my First Framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is my First CocoaPods Framework. Which is very useful to add at Starting of the project.
                       DESC

  s.homepage         = 'https://github.com/chinmaypatel1112/chinmayframework'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chinmaypatel1112' => 'chinmay.patel1112@gmail.com' }
  s.source           = { :git => 'https://github.com/chinmaypatel1112/chinmayframework.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'

  s.source_files = 'Classes/**/*'
  

end
