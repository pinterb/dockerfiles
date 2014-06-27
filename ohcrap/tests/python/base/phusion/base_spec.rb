require_relative 'spec_helper'

packages = [
  'python3',
  'python3-setuptools',
  'python3-pip']

describe "Checks for Phusion Python image" do

  packages.each do|p|
    describe package(p) do
      it { should be_installed }
    end
  end # packages
end

