@{

  # Package Id as specified in the nuspec file
  PackageId = 'chocolateyPkgHelpers'

  # Package Version as specified in the nuspec file
  PackageVersion = '1.0.0'

  # ------- FILES INSTALL -------- #
  # Install location of files in the files directory. (the path to prefix files with when installing)
  #
  # This path must exists !
  #   if not create it in the chocolateyBeforeInstall.ps1 script
  #   also remove it in the chocolateyAfterUninstall.ps1 script
  Prefix = $PSHOME

}