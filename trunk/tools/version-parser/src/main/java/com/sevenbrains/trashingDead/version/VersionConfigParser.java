package com.sevenbrains.trashingDead.version;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Map.Entry;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.tmatesoft.svn.core.wc.SVNDiffStatus;
import org.tmatesoft.svn.core.wc.SVNStatusType;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class VersionConfigParser {
	
	private Collection<SVNDiffStatus> updatedElements;
	private InputStream versionConfig;
	private String version;
	
	public VersionConfigParser(Collection<SVNDiffStatus> updatedElements, InputStream versionConfig, String version){
		this.version = version;
		this.versionConfig = versionConfig;
		this.updatedElements = updatedElements;
	}

	public ByteArrayOutputStream run() {

		Document dom = getDom(versionConfig);

		Map<String, SortedSet<FileVersion>> versionSettings = parseVersionSettings(dom);

		processUpdateFile(versionSettings, updatedElements);
	
		return 	generateNewVersionConfig(versionSettings);
	}

	private ByteArrayOutputStream generateNewVersionConfig(Map<String, SortedSet<FileVersion>> versionSettings) {
		ByteArrayOutputStream out = new  ByteArrayOutputStream();
		OutputStreamWriter writer = null;
		try {
			writer = new OutputStreamWriter(out);
			writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
			writer.write("<config>\n");
			writer.write("\t<versions>\n");
			
			for (Entry<String, SortedSet<FileVersion>> iterable : versionSettings.entrySet()) {
				writer.write("\t\t<path url=\"" + iterable.getKey() + "\">\n");

				for (FileVersion file : iterable.getValue()) {
					writer.write("\t\t\t<file url=\"" + file.getUrl() + "\" version=\"" + file.getVersion()
							+ "\" />\n");
				}
				writer.write("\t\t</path>\n");
			}

			writer.write("\t</versions>\n");
			writer.write("</config>\n");

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(writer);
		}
		return out;
	}

	private void close(OutputStreamWriter writer) {
		try {
			if (writer != null) {
				writer.close();
			}
		} catch (IOException e) {
		}
	}

	private void processUpdateFile(Map<String, SortedSet<FileVersion>> versionSettings, Collection<SVNDiffStatus> cfgFile) {
		try {

			for(SVNDiffStatus dif : cfgFile){
				
				if (dif.getPath().startsWith("server") || dif.getPath().startsWith("tools") || dif.getPath().endsWith("css")
						|| dif.getPath().endsWith("js") || dif.getPath().endsWith("as") || dif.getPath().endsWith("fla")
						|| dif.getPath().endsWith("java") || dif.getPath().endsWith("version-config.xml")
						|| dif.getPath().endsWith("pom.xml")) {
					continue;
				}
				if (dif.getPath().contains("assets")) {
					process(dif.getPath().substring(dif.getPath().indexOf("assets") + "assets".length() + 1),
							versionSettings,dif.getModificationType());
				} else if (dif.getPath().contains("resources")) {
					process(dif.getPath().substring(dif.getPath().indexOf("resources") + "resources".length() + 1),
							versionSettings,dif.getModificationType());
				} else {
					System.out.println("Could not process line: " + dif.getPath() );
				}
				
			}
		} catch (Exception e) {
			System.err.print(e.getStackTrace());
		}

	}

	private void process(String substring, Map<String, SortedSet<FileVersion>> versionSettings,SVNStatusType status) {

		String filename = "";
		String location = "";

		int lastBarPos = substring.lastIndexOf("/");

		if (lastBarPos != -1) {
			location = substring.substring(0, lastBarPos + 1);
			filename = substring.substring(lastBarPos + 1);
		} else {
			filename = substring;
		}

		if (!versionSettings.containsKey(location)) {
			versionSettings.put(location, new TreeSet<FileVersion>());
		}

		updateVersion(filename, versionSettings.get(location), status);

	}

	private void updateVersion(String filename, SortedSet<FileVersion> list, SVNStatusType status) {

		FileVersion currentFile = null;

		for (FileVersion fileVersion : list) {
			if (fileVersion.getUrl().equalsIgnoreCase(filename)) {
				currentFile = fileVersion;
				break;
			}
		}

		if (currentFile != null){ 
			currentFile.setVersion(version);
			if(status == SVNStatusType.STATUS_DELETED) {
				list.remove(currentFile);
			}
		} else {
			list.add(new FileVersion(filename, version));
		}
	}

	private static Document getDom(InputStream input) {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

		try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document dom = db.parse(input);
			return dom;
		} catch (ParserConfigurationException pce) {
			throw new RuntimeException(pce);
		} catch (SAXException se) {
			throw new RuntimeException(se);
		} catch (IOException ioe) {
			throw new RuntimeException(ioe);
		}
	}

	private Map<String, SortedSet<FileVersion>> parseVersionSettings(Document dom) {
		Node settings = dom.getElementsByTagName("config").item(0);

		NodeList nodes = settings.getChildNodes();

		Map<String, SortedSet<FileVersion>> versions = null;

		for (int i = 0; i < nodes.getLength(); i++) {
			Node node = nodes.item(i);

			if ("versions".equals(node.getNodeName())) {
				versions = processVersionsNode((Element) node);
			}
		}

		return versions;
	}

	private Map<String, SortedSet<FileVersion>> processVersionsNode(Element itemsNode) {
		Map<String, SortedSet<FileVersion>> versions = new HashMap<String, SortedSet<FileVersion>>();
		NodeList itemNodes = itemsNode.getChildNodes();
		for (int i = 0; i < itemNodes.getLength(); i++) {
			Node node = itemNodes.item(i);
			if ("path".equals(node.getNodeName())) {
				Element itemNode = (Element) node;

				String url = itemNode.getAttribute("url");

				for (int j = 0; j < itemNode.getChildNodes().getLength(); j++) {
					Node child = itemNode.getChildNodes().item(j);

					if ("file".equals(child.getNodeName())) {
						String fileUrl = ((Element) child).getAttribute("url");
						String version = ((Element) child).getAttribute("version");
						FileVersion file = new FileVersion(fileUrl, version);

						SortedSet<FileVersion> fileVersions = versions.get(url);

						if (fileVersions == null) {
							fileVersions = new TreeSet<FileVersion>();
							versions.put(url, fileVersions);
						}

						fileVersions.add(file);
					}
				}
			}
		}
		return versions;
	}

}
