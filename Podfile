# Uncomment the next line to define a global platform for your project
# platform :ios, '14.5'

workspace 'Prometheus'

def commonPods
	pod 'RxSwift'
	pod 'RxCocoa'
end

target 'Prometheus' do
  # Comment the next line if you don't want to use dynamic frameworks
	project './Prometheus'
  use_frameworks!
	
	commonPods
	
	target 'FeatureIntermediate' do
		project './Prometheus'
	end
	
	target 'RetainCycle' do
		project './Features/RetainCycle/RetainCycle'
	end
	
	target 'Sensor' do
		project './Features/Sensor/Sensor'
	end
	
	target 'ProMotion' do
		project './Features/ProMotion/ProMotion'
	end
end

