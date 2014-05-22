require_relative 'spec_helper'

packages = [
  'python',
  'python2.7',
  'python3',
  'python-pip',
  'python3-pip',
  'python-virtualenv',
  'virtualenvwrapper',
  'python-tox',
  'pbundler',
  'python-sphinx',
  'python3-sphinx',
  'python-docutils',
  'python3-docutils',
  'python-sphinxcontrib.issuetracker',
  'python-sphinxcontrib-httpdomain',
  'python-sphinxcontrib.blockdiag',
  'python-sphinxcontrib.nwdiag',
  'python-sphinxcontrib.seqdiag',
  'python-sphinxcontrib.spelling',
  'python-sphinxcontrib-docbookrestapi']

describe "Checks for Phusion Python image" do

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

end
