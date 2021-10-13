# Uncomment the next line to define a global platform for your project
# platform :ios, '14.5'

workspace 'Prometheus'

target 'Prometheus' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'

  # Pods for Prometheus

  project './Prometheus'
  
  	target 'FeatureIntermediate' do
  		project './Prometheus'
	end
end

target 'RetainCycle' do
  project './RetainCycle/RetainCycle'
end
