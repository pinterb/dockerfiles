require_relative 'spec_helper'

packages = [
  'pylint',
  'python-coverage',
  'python3-coverage',
  'pep8',
  'python3-pep8']

describe "Checks for Phusion Python development image" do

  packages.each do|p|
    describe package(p) do
      it { should be_installed }
    end
  end # packages
end

