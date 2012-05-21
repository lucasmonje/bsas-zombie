package com.sevenbrains.trashingDead.version;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Collection;

import org.apache.log4j.Logger;
import org.tmatesoft.svn.core.wc.SVNDiffStatus;

public class VersionUpdater {
private static Logger logger = Logger.getLogger(VersionUpdater.class);

	public static void main(String[] args){
		
		logger.info("Start process");
		
		Parameters parameters = CommonsUtils.getParamenters(args);
		SvnHelper svnHelper = new SvnHelper(parameters.user,
				parameters.password, parameters.baseRepository);

		Collection<SVNDiffStatus> statuses;
		try {
			statuses = svnHelper.getChanges(
					parameters.branch, parameters.trunk);
			InputStream istream = svnHelper.getVersionConfigIos(parameters.branch,
					parameters.versionFile);
			
			VersionConfigParser versionConfigParser = new VersionConfigParser(
					statuses, istream, parameters.version);
			
			ByteArrayOutputStream newConfig = versionConfigParser.run();
			if (parameters.commit) {
				svnHelper.commit(newConfig, parameters.trunk, parameters.versionFile);
			}
			writeFile(newConfig);
			logger.info("finish process");
		} catch (Exception e) {
			logger.error("process fail");
			logger.error(e);
		}
		
	}

	private static void writeFile(ByteArrayOutputStream os) throws IOException {
		logger.info("write file");
		OutputStream outputStream = new FileOutputStream("version-config.xml");
		os.writeTo(outputStream);
		os.flush();
		os.close();

	}
}
