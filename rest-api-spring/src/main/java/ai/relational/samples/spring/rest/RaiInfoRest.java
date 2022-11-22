package ai.relational.samples.spring.rest;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.relationalai.Client;
import com.relationalai.Database;
import com.relationalai.Engine;
import com.relationalai.HttpError;
import com.relationalai.Json;

@RestController
@RequestMapping("/rai")
public class RaiInfoRest {
    
    @Autowired
    Client raiClient;
    @Value("${rai.database}") String database;
    @Value("${rai.engine}") String engine;

    @GetMapping("/database")
    public Database[] getDatabases() throws HttpError, InterruptedException, IOException{
        return raiClient.listDatabases();
    }

    @GetMapping("/engine/{name}")
    public String getEngines(@PathVariable String name) throws HttpError, InterruptedException, IOException{
        Engine engine = raiClient.getEngine(name);
        return Json.toString(engine);
    }

    @GetMapping("/info")
    public Map<String, String> getSEDatabase() {
        return new HashMap<String, String>(){{
            put("database", database);
            put("engine", engine);
        }};
    }
}
