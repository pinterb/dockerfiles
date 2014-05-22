require_relative 'spec_helper'

describe port(22) do
    it { should be_listening }
end

describe package('build-essential') do
    it { should be_installed }
end

describe package('wget') do
    it { should be_installed }
end

describe package('curl') do
    it { should be_installed }
end

describe package('rsync') do
    it { should be_installed }
end

describe package('tree') do
    it { should be_installed }
end

describe package('less') do
    it { should be_installed }
end

describe package('unzip') do
    it { should be_installed }
end

describe package('locales') do
    it { should be_installed }
end

describe package('ntp') do
    it { should be_installed }
end

describe package('daemontools') do
    it { should be_installed }
end

describe package('git') do
    it { should be_installed }
end

describe package('mercurial') do
    it { should be_installed }
end

describe package('bzr') do
    it { should be_installed }
end

describe package('subversion') do
    it { should be_installed }
end

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

describe service('cron') do
    it { should be_running }
end

describe service('sshd') do
    it { should be_running }
end

describe service('ntpd') do
    it { should be_running }
end

describe command('cat /etc/timezone') do
    it { should return_stdout 'America/Chicago' }
end
