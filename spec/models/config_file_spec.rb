#encoding=utf-8

require 'spec_helper'

describe ConfigFile do
  specify "#path" do
    config = ConfigFile.new
    path = File.join(Rails.root, 'config', 'future.conf')
    expect(config.path).to eq path
  end

  specify "[]" do
    config = ConfigFile.new
    def config.path 
      path = File.join(Rails.root, 'spec', 'test_file', 'future.conf')
    end

    expect(config['螺纹']).to eq '10'
  end
end
