source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
inhibit_all_warnings!

def networking
  pod 'Alamofire', '~> 5.5'
end

def rx
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
end

def core
  networking
  rx
end

target 'MarvelSuperheroes' do
  core

  target 'MarvelSuperheroesTests' do
    inherit! :search_paths
    pod 'RxBlocking', '6.5.0'
    pod 'RxTest', '6.5.0'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end


