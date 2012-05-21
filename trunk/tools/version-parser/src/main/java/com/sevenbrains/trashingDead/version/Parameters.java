package com.sevenbrains.trashingDead.version;

import com.beust.jcommander.Parameter;

public class Parameters {

	@Parameter(names = { "--version", "-v" }, description = "new version", required = true)
	public String version;

	@Parameter(names = { "--trunk", "-t" }, description = "trunk url")
	public String trunk = "trunk/bin";

	@Parameter(names = { "--branch", "-b" }, description = "current prod branch url", required = true)
	public String branch;

	@Parameter(names = { "--file", "-f" }, description = "prod version file")
	public String versionFile = "resources/version-config.xml";

	@Parameter(names = { "--user", "-u" }, description = "user", required = true)
	public String user;

	@Parameter(names = { "--password", "-p" }, description = "password", required = true)
	public String password;

	@Parameter(names = { "--repository", "-r" }, description = "base repository")
	public String baseRepository = "https://bsas-zombie.googlecode.com/svn/";
	
	@Parameter(names = { "--help", "-h" }, description = "Help")
	public boolean help;
	
	@Parameter(names = { "--commit", "-c" }, description = "Commit")
	public boolean commit;
}