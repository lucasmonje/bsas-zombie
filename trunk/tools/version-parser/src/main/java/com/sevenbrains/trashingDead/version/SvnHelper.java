package com.sevenbrains.trashingDead.version;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Collection;
import java.util.LinkedList;

import org.apache.log4j.Logger;
import org.tmatesoft.svn.core.SVNCommitInfo;
import org.tmatesoft.svn.core.SVNDepth;
import org.tmatesoft.svn.core.SVNException;
import org.tmatesoft.svn.core.SVNProperties;
import org.tmatesoft.svn.core.SVNURL;
import org.tmatesoft.svn.core.auth.ISVNAuthenticationManager;
import org.tmatesoft.svn.core.internal.io.dav.DAVRepositoryFactory;
import org.tmatesoft.svn.core.io.ISVNEditor;
import org.tmatesoft.svn.core.io.SVNRepository;
import org.tmatesoft.svn.core.io.SVNRepositoryFactory;
import org.tmatesoft.svn.core.io.diff.SVNDeltaGenerator;
import org.tmatesoft.svn.core.wc.ISVNDiffStatusHandler;
import org.tmatesoft.svn.core.wc.SVNClientManager;
import org.tmatesoft.svn.core.wc.SVNDiffClient;
import org.tmatesoft.svn.core.wc.SVNDiffStatus;
import org.tmatesoft.svn.core.wc.SVNRevision;
import org.tmatesoft.svn.core.wc.SVNStatusType;
import org.tmatesoft.svn.core.wc.SVNWCUtil;

public class SvnHelper {

	private static Logger logger = Logger.getLogger(SvnHelper.class);
	
	private String user;
	private String pass;
	private String baseRepository;

	private ISVNAuthenticationManager authManager;

	public SvnHelper(String user, String password, String baseRepository) {
		this.user = user;
		this.pass = password;
		this.baseRepository = baseRepository;
		logger.debug("create create AuthenticationManager");
		this.authManager = SVNWCUtil.createDefaultAuthenticationManager(
				this.user, pass);
		DAVRepositoryFactory.setup();
	}

	public ByteArrayInputStream getVersionConfigIos(String branch, String filePath)
			throws SVNException {
		
		SVNRepository branchRepository = SVNRepositoryFactory.create(SVNURL
				.parseURIEncoded(baseRepository + "/" + branch));

		branchRepository.setAuthenticationManager(authManager);

		SVNProperties fileProperties = new SVNProperties();
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		logger.info("get file: " + filePath +" to repository");
		branchRepository.getFile(filePath, -1, fileProperties, baos);

		byte[] data = baos.toByteArray();
		ByteArrayInputStream istream = new ByteArrayInputStream(data);

		return istream;
	}

	public Collection<SVNDiffStatus> getChanges(String branch, String trunk)
			throws SVNException {

		SVNClientManager svnManager = SVNClientManager.newInstance();
		svnManager.setAuthenticationManager(authManager);

		SVNDiffClient diffClient = svnManager.getDiffClient();

		SVNURL branchUrl = SVNURL
				.parseURIEncoded(baseRepository + "/" + branch);
		SVNURL trunkUrl = SVNURL.parseURIEncoded(baseRepository + "/" + trunk);
        logger.info("Obtaining the differences of the files");
		final Collection<SVNDiffStatus> statuses = new LinkedList<SVNDiffStatus>();
		diffClient.doDiffStatus(branchUrl, SVNRevision.HEAD, trunkUrl,
				SVNRevision.HEAD, SVNDepth.INFINITY, true,
				new ISVNDiffStatusHandler() {
					@Override
					public void handleDiffStatus(SVNDiffStatus diffStatus)
							throws SVNException {
						if (diffStatus.getModificationType() == SVNStatusType.STATUS_MODIFIED
								|| diffStatus.getModificationType() == SVNStatusType.STATUS_DELETED) {
							statuses.add(diffStatus);
						}
					}
				});
		return statuses;
	}

	public SVNCommitInfo commit(ByteArrayOutputStream newConfig, String trunk, String filePath) throws SVNException {
		logger.info("Start commit");
		SVNRepository trunkRepository = SVNRepositoryFactory.create(SVNURL.parseURIEncoded(baseRepository + "/" + trunk));
		trunkRepository.setAuthenticationManager(authManager);
		ISVNEditor editor = trunkRepository.getCommitEditor("Update version", null);
		
		ByteArrayInputStream oldData = getVersionConfigIos(trunk, filePath);
		
		byte[] data = newConfig.toByteArray();
		ByteArrayInputStream newConfigIstream = new ByteArrayInputStream(data);
		
		SVNCommitInfo result = modifyFile(editor, filePath, oldData, newConfigIstream);
		
		logger.info("Commit succesfull");
		return result;
	}

	private SVNCommitInfo modifyFile(ISVNEditor editor, String filePath, ByteArrayInputStream oldData, 
			ByteArrayInputStream newData) throws SVNException {
		
		logger.info(filePath + " by modifying");
		
		editor.openRoot(-1);
		 editor.openDir(filePath.substring(0,filePath.lastIndexOf("/")), -1);
		editor.openFile(filePath, -1);
		editor.applyTextDelta(filePath, null);

		SVNDeltaGenerator deltaGenerator = new SVNDeltaGenerator();
		String checksum = deltaGenerator.sendDelta(filePath, oldData, 0, newData, editor, true);

		// Closes filePath.
		editor.closeFile(filePath, checksum);

		// Closes dirPath.
		editor.closeDir();

		// Closes the root directory.
		editor.closeDir();

		return editor.closeEdit();
	}
}
