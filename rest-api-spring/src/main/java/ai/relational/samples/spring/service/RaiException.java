package ai.relational.samples.spring.service;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.INTERNAL_SERVER_ERROR)
public class RaiException extends Exception{

    public RaiException(Exception e){
        super("Erro on RAI SDK", e);
    }
    
    RaiException(String msg, Exception e){
        super("Erro on RAI SDK - " + msg, e);
    }
}
