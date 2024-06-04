# project1

# для продукта предусмотрено создание deb пакета

структура и данные берутся из conandata.yml раздел pkgs

сборка продукта ведется через Jenkinsfile вызовом подключаемой Global Pipeline Libraries из ветки debpackage

**`@Library('bld-jenkins-shared-libraries@docker')_`**

вызов модуля сборки пакета в конан файле conanfile.py
```
python_requires = "DebPkg/0.0.1@project1/dev"
...
pkg = self.python_requires["DebPkg"].module.DebBase
pkg.package_install_linux(self)
```
