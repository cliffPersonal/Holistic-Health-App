package example.micronaut.controller;

import java.util.List;
import java.sql.Timestamp;

import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import example.micronaut.domain.SYMPTOM_LOGS;
import example.micronaut.domain.SYMPTOMS;
import example.micronaut.domain.USERS;
import example.micronaut.repository.SymptomLogRepository;
import example.micronaut.repository.SymptomRepository;
import io.micronaut.http.annotation.Body;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Post;
import net.minidev.json.JSONObject;

@Controller("/")
public class SymptomLogsController {
    private final SymptomLogRepository symptomLogRepository;
    private final SymptomRepository symptomRepository;

    SymptomLogsController(SymptomLogRepository symptomLogRepository, SymptomRepository symptomRepository){
        this.symptomLogRepository = symptomLogRepository;
        this.symptomRepository = symptomRepository;
    }

    //Login post
    @Post("addSymptomLog")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response addSymptomLog(int USER_ID, String SYMPTOM, int SEVERITY, String DATE)
    {
        int logID = 0;
        int sympID = symptomRepository.findByName(SYMPTOM).getSYMPTOM_ID();
        int condID = 0;
        Timestamp time = Timestamp.valueOf(DATE);
        
        SYMPTOM_LOGS sLog = new SYMPTOM_LOGS(logID, sympID, USER_ID, SEVERITY, time, condID);

        symptomLogRepository.save(sLog);
        return Response.status(201).entity("Register success.").build();
    }

    @Get("returnSymptomLogs")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response returnSuppLogs(@Body USERS user) {
        int em = user.getUSER_ID();
        List<SYMPTOM_LOGS> myLogs = symptomLogRepository.findByUserId(em);
        JSONObject j = new JSONObject();
        j.put("symptom_logs",myLogs);
        String jsonString = j.toString();
        return Response.status(201).entity(jsonString).build();
    }
}
