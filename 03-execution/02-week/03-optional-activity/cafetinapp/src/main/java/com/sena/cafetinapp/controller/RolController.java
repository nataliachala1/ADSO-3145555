package com.sena.cafetinapp.controller;

import com.fasterxml.jackson.annotation.JsonView;
import com.sena.cafetinapp.dto.request.RolRequestDto;
import com.sena.cafetinapp.dto.response.RolResponseDto;
import com.sena.cafetinapp.dto.view.JsonViews;
import com.sena.cafetinapp.service.RolService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.util.List;

@RestController
@RequestMapping("/api/roles")
@RequiredArgsConstructor
@Tag(name = "Rols", description = "API para gestión de roles de usuario")
public class RolController {

    private final RolService rolService;


    @GetMapping
    @JsonView(JsonViews.Resumen.class)
    public ResponseEntity<List<RolResponseDto>> getAllRoles() {
        return ResponseEntity.ok(rolService.findAll());
    }

    // =============================================
    // GET BY ID → /api/roles/{id}
    // =============================================
    @GetMapping("/{id}")
    @JsonView(JsonViews.Detalle.class)
    public ResponseEntity<RolResponseDto> getRolById(@PathVariable Integer id) {
        return ResponseEntity.ok(rolService.findById(id));
    }

    // =============================================
    // POST → /api/roles
    // =============================================
    @PostMapping
    @JsonView(JsonViews.Detalle.class)
    public ResponseEntity<RolResponseDto> createRol(@Valid @RequestBody RolRequestDto dto) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(rolService.create(dto));
    }

    // =============================================
    // PUT → /api/roles/{id}
    // =============================================
    @PutMapping("/{id}")
    @JsonView(JsonViews.Detalle.class)
    public ResponseEntity<RolResponseDto> updateRol(
            @PathVariable Integer id,
            @Valid @RequestBody RolRequestDto dto) {
        return ResponseEntity.ok(rolService.update(id, dto));
    }

    // =============================================
    // DELETE → /api/roles/{id}
    // =============================================
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRol(@PathVariable Integer id) {
        rolService.delete(id);
        return ResponseEntity.noContent().build();
    }
}