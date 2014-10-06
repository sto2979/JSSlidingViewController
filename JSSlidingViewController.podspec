Pod::Spec.new do |spec|
  spec.name         = 'JSSlidingViewController'
  spec.version      = '1.0'
  spec.platform     = :ios, '6.0'
  spec.license      = 'BSD'
  spec.homepage     = 'https://github.com/sto2979/JSSlidingViewController'
  spec.author       = { 'Jared Sinclair' => 'jaredsinclair.rn@gmail.com' }
  spec.summary      = 'JSSlidingViewController is an easy way to add "slide-to-reveal" style navigation to an iPhone, iPad, or iPod Touch app.'
  spec.source       = { :git => 'https://github.com/sto2979/JSSlidingViewController.git', :tag => 'v1.0' }
  spec.source_files = 'JSSlidingViewController/*.{h,m,c}'
  spec.resources    = 'JSSlidingViewController/*.png'
  spec.requires_arc = true
end