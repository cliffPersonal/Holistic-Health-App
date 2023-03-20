package example.micronaut.controller;

import java.util.List;

import io.micronaut.http.annotation.*;

import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;


import java.util.ArrayList;

import example.micronaut.domain.*;
import example.micronaut.repository.*;
import net.minidev.json.JSONObject;



@Controller("/")
class ConditionController {
    private final ConditionRepository conditionRepository;
    private final SupplementRepository supplementRepository;
    private final UserConditionRepository userConditionRepository;
    private final SymptomRepository symptomRepository;

    ConditionController (ConditionRepository conditionRepository, SupplementRepository supplementRepository, UserConditionRepository userConditionRepository, SymptomRepository symptomRepository)
    {
        this.conditionRepository = conditionRepository;
        this.supplementRepository = supplementRepository;
        this.userConditionRepository = userConditionRepository;
        this.symptomRepository = symptomRepository;
    }

    @Get("allConditions")
    List<CONDITIONS> all()
    {
        return conditionRepository.findAll();
    }

    @Post("getSymptoms")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    //This function returns all symptoms associated with a given condition
    public Response getSymptoms(String condition_name)
    {

        
        List<SYMPTOMS> mySymptoms = symptomRepository.findByCondition(conditionRepository.findByName(condition_name).getCONDITION_ID()); //returns all symptoms
        System.out.println(mySymptoms.size());
        JSONObject j = new JSONObject();
        j.put("symptoms",mySymptoms);
        String jsonString = j.toString();
        return Response.status(201).entity(jsonString).build();
    }

    //given a user, this getInfo function returns a user's given conditions and supplements
    @Post("getConditions")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getInfo(int user_id)
    {
        int id = user_id;
        System.out.println("ID: " + id);
        List<USER_CONDITIONS> myUserConditions = userConditionRepository.findById(id);
        System.out.println("GOOD");
        List<String> myConditions = new ArrayList<String>();
        CONDITIONS tempCon;
        for (int i = 0; i < myUserConditions.size(); ++i)
        {
            tempCon = conditionRepository.findById(myUserConditions.get(i).getCONDITION_ID());
            myConditions.add(tempCon.getCONDITION_NAME());
        }
        //myConditions has all the condition names now
        JSONObject j = new JSONObject();
        j.put("conditions",myConditions);
        String jsonString = j.toString();
        return Response.status(201).entity(jsonString).build();
    }

    ConditionRepository returnRepo()
    {return this.conditionRepository;}

}

