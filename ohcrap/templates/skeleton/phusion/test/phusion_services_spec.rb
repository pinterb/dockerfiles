require_relative 'spec_helper'

describe "Service checks for Phusion base image" do
  describe "Core services should be running" do
    describe service('sshd') do
      it { should be_running   }
    end

    describe port(22) do
      it {should be_listening }
    end

    describe service('cron') do
       it { should be_running }
    end
  end # services
end

