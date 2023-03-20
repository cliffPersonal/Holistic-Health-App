package example.micronaut.controller;

import example.micronaut.repository.*;
import io.micronaut.http.annotation.*;

import javax.validation.constraints.NotBlank;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import java.security.Security;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import example.micronaut.domain.USERS;
import example.micronaut.repository.UserRepository;

@Controller("/")
public class RegisterController {
    private final UserRepository userRepository;

    RegisterController(UserRepository userRepository){
        this.userRepository = userRepository;
    }

    //Adding Users to the database
    @Post("register")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response register(@Body USERS user)
    {
        if(userRepository.findByEmail(user.getEMAIL()).orElse(null) != null)
        {
            return Response.status(409).entity("Register failed. Email exists already.").build();
        }
        else {
            userRepository.saveAll(Arrays.asList(user));
            return Response.status(201).entity("Register success.").build();
        }
    }

    @Get("loginFailed")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public String loginFailed() {
        return "Login Failed";
    }

    @Get("loggedOut")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public String LoggedOut() {
        return "Logged Out";
    }

    @Get("loginSuccess")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public String loginSuccess() {
        return "Login Success";
    }

}
