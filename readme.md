# Multi-Target Sample

This is a work in progress of how to structure a single visual studio project
and to output assemblies targeting multiple .net frameworks.

The two tricky parts are first dealing with nuget packages that are also
multi-targeted.  When a nuget package is first installed it will apply
a reference to the proper assembly based on the target framework of
project being installed into.

This means that if I want to build my project for both .net35 and .net40
just supplying /p:targetFrameworkVersion=v3.5 or /p:targetFrameworkVersion=v4.0
will not work because the actual csproj file will be referencing the wrong nuget
package assemblies.

The brute force solution is to simply make a project per target framework,
explicitly set the target framework version in the project then used
linked sources and conditional compilation symbols where appropriate.
This is the approach taken in this sample.

The second issue is dealing with TFS Autobuild.  Now, this is only a TFS
problem any other type of build tool / system should have no problems
being scripted to support this approach, however in our enterprise environment
we have to use TFS2010 and we have get metrics on unit tests, code coverage,
and code analysis which means I have to use that crazy complicated, 
yet super simple to understand, visual workflow build template.

Two noteable issues creep up with the default TFS build template.

TFS overrides your output directory so assemblies with the same
names get overwritten.  This causes problems not only for my project's
assemblies but also the referenced assemblies.

We solve our first problem by tacking on a .{targetFrameworkVersion}
to our assembly name so they are unique.  Once we go to build our final
nuget package we can reorganize, rename, and sign them.

The second problem of dealing with references targeting different
versions has not been solved yet.  There are two problems, first
if you run msbuild in parallel with /m switch you will likely get
strange errors as two processes are trying to copy / write the same
named file to the same directory.  Second the last assembly written
wins so when it comes to run tests you will not have all the references
located in your output directory, you will only have the last one written.

The second major issue with TFS autobuild is the manor it runs tests.
TFS first compiles all projects, then executes the test task.  However
as noted previously chances are we have some invalid references, but even
worse is that mstest has to perform test discovery for all tests in all assemblies.
When it discovers tests it generates an id based on test Namespace,Class,TestMethod
but not Assembly Name, thus most of tests are discovered as duplicates and only
a fraction of them are executed.

The final piece is figuring out after all of this how to generate a multi-target
nuget package that will be copied to the drop location.  This is easy with msbuild,
powershell, batch file, etc, the difficulty will be locating the proper assemblies,
renaming them, then packaging them.

Possible solutions:

1. Completely customize the TFS Build Template in a way which I have no idea how to accomplish.
  * This cannot provide repeatability on local workstations
  * This is complicated
  * This is very difficult to test, basically trial and error which is very slow and effecient to develop

2. Do it all with MSBuild
  * This would be the easier way
  * Not sure how to integrate straight msbuild with the TFS metrics like coverage, test results, etc
  * Can be repeatable on both the build server and local dev machines

3. Use something super easy like PSake
  * This would be the best approach as long as I can get TFS build metric

