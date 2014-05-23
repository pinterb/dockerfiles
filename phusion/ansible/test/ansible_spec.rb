require_relative 'spec_helper'

ansible_version='ansible 1.6.1'

packages = [
  'libyaml-dev',
  'python-yaml',
  'python3-yaml',
  'python-jinja2',
  'python3-jinja2',
  'python-jinja2-doc']

describe "Checks for Phusion Ansible image" do

  packages.each do|p|
    describe package(p) do
      it { should be_installed }
    end
  end # packages

  describe "Checks for important directories and files" do
    describe file('/home/app/.virtualenvs') do
        it { should be_directory }
    end
  end # directories and files

  describe "Checks for expected Ansible version" do
    describe command('ansible --version | awk -F " " \'{print $1 " " $2}\'') do
      it { should return_stdout ansible_version }
    end
  end # ansible version
end
