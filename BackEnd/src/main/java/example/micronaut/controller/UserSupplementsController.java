package example.micronaut.controller;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import example.micronaut.domain.*;
import example.micronaut.repository.*;

import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Post;
import io.micronaut.scheduling.TaskExecutors;
import javax.ws.rs.core.Response;
import io.micronaut.scheduling.annotation.ExecuteOn;
import net.minidev.json.JSONObject;

@Controller("/USERSUPPLEMENTS")
@ExecuteOn(TaskExecutors.IO)

class UserSupplementsController {
    private final UserSupplementsRepository userSupplementsRepository;
    private final SupplementRepository supplementRepository;
    UserSupplementsController (UserSupplementsRepository userSupplementsRepository, SupplementRepository supplementRepository)
    {
        this.userSupplementsRepository = userSupplementsRepository;
        this.supplementRepository = supplementRepository;
    }


    @Get("/")
    List<USER_SUPPLEMENTS> all()
    {
        return userSupplementsRepository.findAll();
    }


    @Post("/addSupplement")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response postSupplement(int user_id, String name)
    {
        SUPPLEMENTS tempSupple = supplementRepository.findByName(name);
        USER_SUPPLEMENTS newSupp = new USER_SUPPLEMENTS(0, user_id, tempSupple.getSUPPLEMENT_ID());
        userSupplementsRepository.save(newSupp);
        return Response.status(201).build();
    }
    //CREATE TABLE user_conditions (user_condition_id int, user_id int, condition_id int);
    @Post("/deleteSupplement")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteSupplement(int user_id, String supplement){

        SUPPLEMENTS curSupp = supplementRepository.findByName(supplement);
        int suppID = curSupp.getSUPPLEMENT_ID();
        USER_SUPPLEMENTS entity;
        List<USER_SUPPLEMENTS> tempList = userSupplementsRepository.findById(user_id);
        for (int i = 0; i < tempList.size(); ++i)
        {
            if (tempList.get(i).getSUPPLEMENT_ID() == suppID)
            {
                entity = tempList.get(i);
                userSupplementsRepository.delete(entity);
                return Response.status(201).build();
            }
        }

        return Response.status(409).build();
    }

    @Post("/getSupplements")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getSupplements(USERS user)
    {

        List<USER_SUPPLEMENTS> myUserSupplements = userSupplementsRepository.findById(user.getUSER_ID());
        List<String> mySupplements = new ArrayList<String>();
        SUPPLEMENTS supp;
        for (int i =0; i < myUserSupplements.size();++i)
        {
            int id = myUserSupplements.get(i).getSUPPLEMENT_ID();
            supp = supplementRepository.findById(id);
            mySupplements.add(supp.getDESCRIPTION());
        }

        JSONObject j = new JSONObject();
        j.put("supplements",mySupplements);
        String jsonString = j.toString();
        return Response.status(201).entity(jsonString).build();
    }



    UserSupplementsRepository returnRepo()
    {return this.userSupplementsRepository;}

}


