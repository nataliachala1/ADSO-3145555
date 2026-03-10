package com.sena.cafetinapp.service.impl;

import com.sena.cafetinapp.dto.request.RolRequestDto;
import com.sena.cafetinapp.dto.response.RolResponseDto;
import com.sena.cafetinapp.model.Rol;
import com.sena.cafetinapp.repository.RolRepository;
import com.sena.cafetinapp.service.RolService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RolServiceImpl implements RolService {

    private final RolRepository rolRepository;

    @Override
    public List<RolResponseDto> findAll() {
        return rolRepository.findAll()
                .stream()
                .map(this::toResponseDto)
                .collect(Collectors.toList());
    }
    @Override
    public RolResponseDto findById(Integer id) {
        Rol rol = rolRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Rol no encontrado con id: " + id));
        return toResponseDto(rol);
    }

    @Override
    public RolResponseDto create(RolRequestDto dto) {
        if (rolRepository.existsByName(dto.getName())) {
            throw new RuntimeException("Ya existe un rol con el nombre: " + dto.getName());
        }
        Rol rol = Rol.builder()
                .name(dto.getName())
                .description(dto.getDescription())
                .build();
        return toResponseDto(rolRepository.save(rol));
    }

    @Override
    public RolResponseDto update(Integer id, RolRequestDto dto) {
        Rol rol = rolRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Rol no encontrado con id: " + id));
        rol.setName(dto.getName());
        rol.setDescription(dto.getDescription());
        return toResponseDto(rolRepository.save(rol));
    }

    @Override
    public void delete(Integer id) {
        if (!rolRepository.existsById(id)) {
            throw new RuntimeException("Rol no encontrado con id: " + id);
        }
        rolRepository.deleteById(id);
    }

    private RolResponseDto toResponseDto(Rol rol) {
        return RolResponseDto.builder()
                .idRol(rol.getIdRol())
                .name(rol.getName())
                .description(rol.getDescription())
                .build();
    }
}