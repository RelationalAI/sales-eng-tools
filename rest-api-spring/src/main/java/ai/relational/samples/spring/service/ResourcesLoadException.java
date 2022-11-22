package ai.relational.samples.spring.service;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.INTERNAL_SERVER_ERROR)
public class ResourcesLoadException extends Exception{

    public ResourcesLoadException(String resourceName, Exception e){
        super("Error on load ", e);
    }
}
