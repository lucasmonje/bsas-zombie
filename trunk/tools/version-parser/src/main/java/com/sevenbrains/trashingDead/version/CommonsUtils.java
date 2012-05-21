package com.sevenbrains.trashingDead.version;

import org.apache.log4j.Logger;

import com.beust.jcommander.JCommander;
import com.beust.jcommander.ParameterException;

public class CommonsUtils {
	
	private static Logger logger = Logger.getLogger(CommonsUtils.class);
	
	public static Parameters getParamenters(String[] args) {
		
		logger.debug("Obtaining parameters");
		Parameters parameters = new Parameters();
        JCommander commander = new JCommander(parameters);
        
        try {
            commander.parse(args);
        } catch (ParameterException e) {
            logger.error(e.getMessage());
            commander.usage();
            System.exit(1);
        }
        
        if (parameters.help) {
            commander.usage();
            System.exit(0);
        }
        return parameters;
	}
}
