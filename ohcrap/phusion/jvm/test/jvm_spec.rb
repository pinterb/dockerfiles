require_relative 'spec_helper'

packages = []

describe "Checks for Phusion jvm image" do

  packages.each do|p|
    describe package(p) do
      it { should be_installed }
    end
  end # packages

  describe "Checks for important directories and files" do
    describe file('/etc/profile.d/jdk.sh') do
        it { should be_file }
    end

    describe file('/usr/lib/jvm/java-8-oracle') do
        it { should be_directory }
    end
  end # directories and files

  describe "Checks for expected java version" do
    describe command('cat /etc/profile.d/jdk.sh | grep "JAVA_HOME=/usr/lib/jvm/java-8-oracle"') do
      it { should return_exit_status 0 }
    end

    describe command('cat /usr/lib/jvm/java-8-oracle/release | grep "1.8.0_05"') do
      it { should return_exit_status 0 }
    end
  end # java version
end
