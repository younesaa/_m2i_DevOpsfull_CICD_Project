package com.matawan.nicefc.service.integrationTest;

import com.matawan.nicefc.dto.TeamDto;
import com.matawan.nicefc.service.TeamService;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Integration tests for the {@code TeamService} class.
 */
@SpringBootTest
@Transactional
public class teamServiceIntegrationTest {

    @Autowired
    private TeamService teamService;

    /**
     * Test for adding a team and checking if it exists.

    @Test
    void testAddTeam() {
        TeamDto teamDto = new TeamDto();
        teamDto.setName("TestTeam");
        teamDto.setAcronym("TTT");
        teamDto.setBudget(BigDecimal.valueOf(1500.0));

        teamService.addTeam(teamDto);

        assertTrue(teamService.existsByName("TestTeam"));
    }
     */
    /**
     * Test for checking if a team with a given name exists (expected result: true).

    @Test
    void testExistsByName_True() {
        TeamDto teamDto = new TeamDto();
        teamDto.setName("TestTeam");
        teamDto.setAcronym("TTT");
        teamDto.setBudget(BigDecimal.valueOf(1500.0));

        teamService.addTeam(teamDto);

        assertTrue(teamService.existsByName("TestTeam"));
    }
     */
    /**
     * Test for checking if a team with a non-existing name exists (expected result: false).
     */
    /*
    @Test
    void testExistsByName_False() {
        assertFalse(teamService.existsByName("NonExistingTeam"));
    }
    */
    /**
     * Test for retrieving teams with valid parameters.

    @Test
    void testGetTeams() {
        int page = 0;
        int size = 10;
        String sortBy = "name";

        TeamDto teamDto = new TeamDto();
        teamDto.setName("TestTeam");
        teamDto.setAcronym("TTT");
        teamDto.setBudget(BigDecimal.valueOf(1500.0));
        teamService.addTeam(teamDto);

        TeamDto teamDto1 = new TeamDto();
        teamDto1.setName("TestTeam1");
        teamDto1.setAcronym("TTT");
        teamDto1.setBudget(BigDecimal.valueOf(1500.0));
        teamService.addTeam(teamDto1);

        TeamDto teamDto2 = new TeamDto();
        teamDto2.setName("TestTeam2");
        teamDto2.setAcronym("TTT");
        teamDto2.setBudget(BigDecimal.valueOf(1500.0));
        teamService.addTeam(teamDto2);

        Page<TeamDto> result = teamService.getTeams(page, size, sortBy);

        assertTrue(result.getTotalElements() > 0);
    }
     */
}
