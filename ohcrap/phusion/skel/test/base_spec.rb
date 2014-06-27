require_relative 'spec_helper'

packages = [
  'build-essential',
  'wget',
  'curl',
  'rsync',
  'tree',
  'less',
  'unzip',
  'locales',
  'ntp',
  'daemontools',
  'git',
  'mercurial',
  'bzr',
  'subversion']

describe "Checks for Phusion base image" do

  packages.each do|p|
    describe package(p) do
      it { should be_installed }
    end
  end # packages

  describe command('cat /etc/timezone') do
    it { should return_stdout 'America/Chicago' }
  end # timezone

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

    describe service('ntpd') do
      it { should be_running }
    end
  end # services

  describe "Groups and Users should exist" do
    describe user('root') do
      it { should exist }
      it { should have_home_directory '/root' }
    end

    describe group('app') do
      it { should exist }
    end

    describe user('app') do
      it { should exist }
      it { should belong_to_group 'app' }
      it { should have_home_directory '/home/app' }
    end

    describe group('log') do
      it { should exist }
    end

    describe user('log') do
      it { should exist }
      it { should belong_to_group 'log' }
    end
  end # groups and users
end

