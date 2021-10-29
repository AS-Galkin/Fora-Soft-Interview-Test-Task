platform :ios, '14.5'
inhibit_all_warnings!
use_frameworks!

def shared_pods
  pod 'Alamofire', '~> 5.4'
end

abstract_target 'App' do
    shared_pods
    target 'ForaSoftInterview'
    abstract_target 'TestGroup' do
        target 'ForaSoftInterviewTests'
    end
end
