package com.sena.cafetinapp.controller;

import com.fasterxml.jackson.annotation.JsonView;
import com.sena.cafetinapp.dto.request.PersonRequestDto;
import com.sena.cafetinapp.dto.response.PersonResponseDto;
import com.sena.cafetinapp.dto.view.JsonViews;
import com.sena.cafetinapp.service.PersonService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.util.List;

@RestController
@RequestMapping("/api/persons")
@RequiredArgsConstructor
@Tag(name = "Persons", description = "API para gestión de personas")
public class PersonController {

    private final PersonService personService;

    // =============================================
    // GET ALL → /api/persons
    // =============================================
    @GetMapping
    @JsonView(JsonViews.Resumen.class)
    public ResponseEntity<List<PersonResponseDto>> getAllPersons() {
        return ResponseEntity.ok(personService.findAll());
    }

    // =============================================
    // GET BY ID → /api/persons/{id}
    // =============================================
    @GetMapping("/{id}")
    @JsonView(JsonViews.Detalle.class)
    public ResponseEntity<PersonResponseDto> getPersonById(@PathVariable Integer id) {
        return ResponseEntity.ok(personService.findById(id));
    }

    // =============================================
    // POST → /api/persons
    // =============================================
    @PostMapping
    @JsonView(JsonViews.Detalle.class)
    public ResponseEntity<PersonResponseDto> createPerson(
            @Valid @RequestBody PersonRequestDto dto) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(personService.create(dto));
    }

    // =============================================
    // PUT → /api/persons/{id}
    // =============================================
    @PutMapping("/{id}")
    @JsonView(JsonViews.Detalle.class)
    public ResponseEntity<PersonResponseDto> updatePerson(
            @PathVariable Integer id,
            @Valid @RequestBody PersonRequestDto dto) {

        return ResponseEntity.ok(personService.update(id, dto));
    }

    // =============================================
    // DELETE → /api/persons/{id}
    // =============================================
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePerson(@PathVariable Integer id) {
        personService.delete(id);
        return ResponseEntity.noContent().build();
    }
}