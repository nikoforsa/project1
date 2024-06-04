from conans import ConanFile
from conan.tools.cmake import CMake, CMakeToolchain
from conan.tools.files import copy
import os, subprocess

class project1Server(ConanFile):
    name = os.environ.get('NAME_PROJECT', "project1")
    url = "https://git.com/vts/project1"
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps", "MSBuildDeps", "VirtualRunEnv"
    exports_sources = "src/*"
    exports = "README.md", "Package/data/*"
    keep_imports = True
    image_path = os.environ.get('STF_BUILD_IMAGE_PATH')
    python_requires = "DebPkg/0.0.1@project1/dev"
    #python_requires_extend = "DebPkg.DebBase"
    home_dir = os.environ.get('HOME_DIRECTORY', '/home/user/')
    package_dir = os.environ.get('PACKAGE_DIRECTORY', '/home/user/package/')

    def init(self):
        if os.environ.get('VERSION_PROJECT'):
            self.version = os.environ.get('VERSION_PROJECT', '0.0.1')
        #else:
        #    self.version = self.conan_data["pkgs"]["control"]["Version"]

    def generate(self):
        tc = CMakeToolchain(self)
        tc.cache_variables["CONAN_PACKAGE_VERSION"] = self.version
        tc.generate()

        copy(self, '*.*', src=os.path.join(self.recipe_folder, 'Package', 'data'), dst='bin')

    def build_requirements(self):
        self.test_requires("gtest/0.0.1@project1/stable")
        
    def requirements(self):
        self.requires('project1-1/0.0.1@project1/stable')

    def build(self):
        cmake = CMake(self)
        cmake.configure(build_script_folder="src")
        cmake.build()
        # cmake.test()

    def package(self):
        if self.image_path:
            dst_folder = self.image_path

            copy(self, 'README.md', src=self.recipe_folder, dst=dst_folder)
            copy(self, '*', src=os.path.join(self.build_folder, 'bin'), dst=dst_folder, excludes=['*-test*'])

            for dep in self.dependencies.values():
                for bindir in dep.cpp_info.bindirs:
                    copy(self, '*.dll', src=bindir, dst=dst_folder, excludes=["*support*", "*grdlic*", "libcrypto*", "libssl*", "engines-1.1/*.so"])
                    copy(self, '*.pdb', src=bindir, dst=dst_folder)

                for libdir in dep.cpp_info.libdirs:
                    copy(self, '*.so*', src=libdir, dst=dst_folder, excludes=["*support*", "*grdlic*", "libcrypto*", "libssl*", "engines-1.1/*.so"])

        if self.settings.os == 'Linux':
            #and self.settings.build_type == 'Release':
            dst_folder = self.package_folder+'/bin/'
            dst_path = "bin"
            copy(self, self.name, src=dst_path, dst=dst_folder, keep_path=False)
            for dep in self.dependencies.values():
                for libdir in dep.cpp_info.libdirs:
                    copy(self, 'lib*.so*', src = libdir, dst = dst_folder, excludes=["*support*", "*grdlic*", "libcrypto*", "libssl*", "engines-1.1/*.so"])

            print("-----------вызов модуля сборки пакета в конан файле conanfile.py------------")
            pkg = self.python_requires["DebPkg"].module.DebBase
            pkg.package_install_linux(self, dst_folder)
