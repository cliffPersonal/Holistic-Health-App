package example.micronaut.controller;

import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import example.micronaut.domain.USERS;
import example.micronaut.repository.UserRepository;
import io.micronaut.http.annotation.Body;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Post;
import net.minidev.json.JSONObject;

@Controller("/")
public class LoginController {
    private final UserRepository userRepository;

    LoginController(UserRepository userRepository){
        this.userRepository = userRepository;
    }

    //Login post
    @Post("login")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response login(@Body USERS user)
    {
        //checks to see if there that email exists in database
        if(userRepository.findByEmail(user.getEMAIL()).orElse(null) == null)
        {
            System.out.println(user.toString());
            return Response.status(409).entity("Login failed. Email does not exist.").build();
        }
        //email exists
        USERS temp = userRepository.returnUser(user.getEMAIL()); //gets
        System.out.println(temp.getPASSWORD() + " " + user.getPASSWORD());
        if (temp.getPASSWORD().equals(user.getPASSWORD()) == false)
        {
            System.out.println("Login failed. Pass does not match.");
            return Response.status(409).entity("Login failed. Pass does not match.").build();
        }
        else {
//            userRepository.saveAll(Arrays.asList(user));
//            return Response.status(201).entity("Login success.").build();
                USERS loggedInUser = userRepository.returnUser(user.getEMAIL());

                    String jsonString;
                    JSONObject j= new JSONObject();
                    j.put("USER_ID", loggedInUser.getUSER_ID());
                    j.put("EMAIL", loggedInUser.getEMAIL());
                    j.put("PASSWORD", loggedInUser.getPASSWORD());
                    j.put("FIRSTNAME", loggedInUser.getFIRSTNAME());
                    j.put("LASTNAME", loggedInUser.getLASTNAME());
                    j.put("BIRTHDATE", loggedInUser.getBIRTHDATE().toString());
                    //System.out.println(loggedInUser.getBIRTHDATE() + " is the birthdate");
                    jsonString = j.toString();
                    System.out.println(jsonString);
            return Response.status(201).entity(jsonString).build();
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
