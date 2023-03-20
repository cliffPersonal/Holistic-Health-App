package example.micronaut.controller;

import java.sql.Timestamp;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import example.micronaut.domain.SUPPLEMENT_LOGS;
import example.micronaut.domain.USERS;
import example.micronaut.repository.SupplementLogRepository;
import example.micronaut.repository.SupplementRepository;
import io.micronaut.http.annotation.Body;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Post;
import net.minidev.json.JSONObject;

@Controller("/")
public class SupplementLogsController {
    private final SupplementLogRepository supplementLogRepository;
    private final SupplementRepository supplementRepository;

    SupplementLogsController(SupplementLogRepository supplementLogRepository, SupplementRepository supplementRepository){
        this.supplementLogRepository = supplementLogRepository;
        this.supplementRepository = supplementRepository;
    }

    //Login post
    @Post("addSupplementLog")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response addSupplementLog(int USER_ID, String SUPPLEMENT, String DATE)
    {

        int logID = 0;
        int suppID = supplementRepository.findByName(SUPPLEMENT).getSUPPLEMENT_ID();
        int dosage = 0;
        String unit = "mg";
        Timestamp time = Timestamp.valueOf(DATE);


        SUPPLEMENT_LOGS sLog = new SUPPLEMENT_LOGS(logID, suppID, USER_ID, dosage, unit, time);
        supplementLogRepository.save(sLog);
        return Response.status(201).entity("Register success.").build();
    }

    @Post("returnSupplementLogs")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response returnSuppLogs(@Body USERS user) {
        int em = user.getUSER_ID();
        List<SUPPLEMENT_LOGS> myLogs = supplementLogRepository.findByUserId(em);
        JSONObject j = new JSONObject();
        j.put("supplement_logs",myLogs);
        String jsonString = j.toString();
        return Response.status(201).entity(jsonString).build();
    }
}
