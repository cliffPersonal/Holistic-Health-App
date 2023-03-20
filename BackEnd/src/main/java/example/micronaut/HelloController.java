package example.micronaut;

import io.micronaut.http.MediaType;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Produces;

@Controller("/hello")
public class HelloController {
    @Get(produces = MediaType.TEXT_PLAIN)
    public String sayHello() {
        return "I am excited for tomorrow.";
    }
}

