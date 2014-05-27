require_relative 'spec_helper'

packages = []

describe "Checks for Phusion graven image" do

  packages.each do|p|
    describe package(p) do
      it { should be_installed }
    end
  end # packages

  describe "Checks for important directories and files" do
    describe file('/etc/profile.d/gradle.sh') do
        it { should be_file }
    end

    describe file('/etc/profile.d/maven.sh') do
        it { should be_file }
    end

    describe file('/usr/local/gradle/gradle-1.12') do
        it { should be_directory }
    end

    describe file('/usr/local/gradle/latest') do
        it { should be_directory }
        it { should be_linked_to '/usr/local/gradle/gradle-1.12' }
    end

    describe file('/usr/local/maven/apache-maven-3.2.1') do
        it { should be_directory }
    end

    describe file('/usr/local/maven/latest') do
        it { should be_directory }
        it { should be_linked_to '/usr/local/maven/apache-maven-3.2.1' }
    end

    describe file('/root/.m2') do
        it { should be_directory }
        it { should be_grouped_into 'root' }
        it { should be_owned_by 'root' }
    end
  end # directories and files

  describe "Checks for expected gradle version" do
    describe command('cat /etc/profile.d/gradle.sh | grep "GRADLE_HOME=/usr/local/gradle/latest"') do
      it { should return_exit_status 0 }
    end

    describe command('/usr/local/gradle/latest/bin/gradle -version | grep "Gradle 1.12"') do
      it { should return_exit_status 0 }
    end
  end # gradle version

  describe "Checks for expected maven version" do
    describe command('cat /etc/profile.d/maven.sh | grep "M3_HOME=/usr/local/maven/latest"') do
      it { should return_exit_status 0 }
    end

    describe command('/usr/local/maven/latest/bin/mvn --version | grep "Apache Maven 3.2.1"') do
      it { should return_exit_status 0 }
    end
  end # maven version
end
