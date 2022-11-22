package ai.relational.samples.spring.bootstrap;

import java.io.IOException;
import java.io.InputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

import com.relationalai.Client;
import com.relationalai.Config;

@Component
public class RelConfig implements ApplicationListener<ApplicationReadyEvent> {

    final Logger LOGGER = LoggerFactory.getLogger(getClass());
    final String raiConfigFilePath = "rai/config";
        
    @Value("${rai.profile}") String profile;

    @Override
    public void onApplicationEvent(ApplicationReadyEvent event) {
        try {
            raiClient();
            LOGGER.info("RAI was sucessfully configured");
        } catch (IOException e) {
            LOGGER.error("RAI configuration error on config file loading", e);
        }
    }
    
    @Bean
    Client raiClient() throws IOException {
        ClassLoader cl = this.getClass().getClassLoader();
        InputStream inputStream = cl.getResourceAsStream(raiConfigFilePath);
        Config raiConfig = Config.loadConfig(inputStream, profile);
        Client raiClient = new Client(raiConfig);
        LOGGER.info("RAI Client was sucessfully created");
        return raiClient;
    }
}
