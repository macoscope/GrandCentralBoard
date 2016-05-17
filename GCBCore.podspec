Pod::Spec.new do |s|

  s.name = 'GCBCore'
  s.version = '1.0.0'
  s.license = 'GPLv3'
  s.summary = 'Hang a TV in your open space or team room to show everyone what`s up and get them up to speed.'
  s.homepage = 'https://github.com/macoscope/GrandCentralBoard'
  s.authors = { 'Oktawian Chojnacki' => 'oktawian@me.com' }
  s.source = { git: 'https://github.com/macoscope/GrandCentralBoard.git', tag: s.version }
  
  s.requires_arc = true
  s.tvos.deployment_target = '9.0'

  s.source_files = 'GCBCore/**/*.swift'
  s.resource_bundles = {
    'GCBCore' => ['GCBCore/**/*.xib']
  }

  s.dependency 'Alamofire', '~> 3.0'
  s.dependency 'Decodable', '~> 0.4'

end

