package example.micronaut.controller;

import java.util.List;

import io.micronaut.http.annotation.*;

import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;


import example.micronaut.domain.*;
import example.micronaut.repository.*;
import io.micronaut.scheduling.TaskExecutors;
import io.micronaut.scheduling.annotation.ExecuteOn;


@Controller("/USERCONDITIONS")
@ExecuteOn(TaskExecutors.IO)

class UserConditionsController {

    private final UserConditionRepository userConditionRepository;
    private final ConditionRepository conditionRepository;
    UserConditionsController (UserConditionRepository userConditionRepository ,ConditionRepository conditionRepository)
    {
        //this.userConditionsRepository = userConditionsRepository;
        this.userConditionRepository = userConditionRepository;
        this.conditionRepository = conditionRepository;
    }


    @Get("/")
    List<USER_CONDITIONS> all()
    {
        return userConditionRepository.findAll();
    }


    @Post("/addCondition")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response postUser(int user, String name)
    {

        CONDITIONS tempCondition = conditionRepository.findByName(name);

        System.out.println("conditions: " + tempCondition.getCONDITION_NAME() + " user_id: " + user + " " + name);
        USER_CONDITIONS newCondition = new USER_CONDITIONS(0,user,tempCondition.getCONDITION_ID());
        System.out.println("ABOUT TO SAVE TO DB NOW");
        //userConditionRepository.update(newCondition);
        userConditionRepository.save(newCondition);
        return Response.status(201).build();
    }
    //CREATE TABLE user_conditions (user_condition_id int, user_id int, condition_id int);
    @Post("/deleteCondition")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteCondition(int user_id, String condition_name){
        CONDITIONS curCond = conditionRepository.findByName(condition_name);
        int condition_id = curCond.getCONDITION_ID();
        USER_CONDITIONS entity;
        List<USER_CONDITIONS> tempList = userConditionRepository.findById(user_id);
        for (int i = 0; i < tempList.size(); ++i)
        {
            if (tempList.get(i).getCONDITION_ID() == condition_id)
            {
                entity = tempList.get(i);
                userConditionRepository.delete(entity);
                return Response.status(201).build();
            }
        }

        return Response.status(409).build();
    }

    UserConditionRepository returnRepo()
    {return this.userConditionRepository;}
}

