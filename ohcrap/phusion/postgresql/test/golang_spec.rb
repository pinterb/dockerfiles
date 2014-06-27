require_relative 'spec_helper'

packages = []
root_directories = [
  '/root/gocode',
  '/root/gocode/src',
  '/root/gocode/bin',
  '/root/gocode/pkg',
  '/usr/local/go',
  '/usr/local/golangthirdparty',
  '/usr/local/golangthirdparty/src',
  '/usr/local/golangthirdparty/bin',
  '/usr/local/golangthirdparty/pkg'
]

describe "Checks for Phusion golang image" do

  packages.each do|p|
    describe package(p) do
      it { should be_installed }
    end
  end # packages

  describe "Checks for important directories and files" do
    describe file('/etc/profile.d/go.sh') do
        it { should be_file }
    end

    root_directories.each do|rd|
      describe file(rd) do
        it { should be_directory }
        it { should be_grouped_into 'root' }
        it { should be_owned_by 'root' }
      end
    end # root directories
  end # directories and files

  describe "Checks for expected go version" do
    describe command('cat /etc/profile.d/go.sh | grep "GOROOT=/usr/local/go"') do
      it { should return_exit_status 0 }
    end

    describe command('/usr/local/go/bin/go version | grep "go1.2.2"') do
      it { should return_exit_status 0 }
    end
  end # go version
end
