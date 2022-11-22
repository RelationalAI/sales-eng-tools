package ai.relational.samples.spring.rest;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ai.relational.samples.spring.service.RaiException;
import ai.relational.samples.spring.service.ResourcesLoadException;
import ai.relational.samples.spring.service.RelGraphService;
import ai.relational.samples.spring.service.RelGraphService.Graph;

@RestController
@RequestMapping("/graph")
public class GraphRest {
    
    @Autowired
    RelGraphService graphService;
    
    @GetMapping("/{relFileName}")
    public Graph getGraph(@PathVariable String relFileName, 
                        @RequestParam Map<String, String> params) 
                        throws ResourcesLoadException, RaiException{
        return graphService.query(relFileName, params);
    }

    @GetMapping("/{dbName}/{relFileName}")
    public Graph getGraphOnDB(@PathVariable String dbName,
                        @PathVariable String relFileName, 
                        @RequestParam Map<String, String> params) 
                        throws ResourcesLoadException, RaiException{
        return graphService.query(dbName, relFileName, params);
    }
}
