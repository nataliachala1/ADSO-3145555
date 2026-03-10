package com.sena.cafetinapp.service;

import java.util.List;

public interface GenericService <RequestDto, ResponseDto, ID> {

    /**
     * Obtener todos los registros.
     */
    List<ResponseDto> findAll();

    /**
     * Buscar por ID.
     */
    ResponseDto findById(ID id);

    /**
     * Crear un nuevo registro.
     */
    ResponseDto create(RequestDto dto);

    /**
     * Actualizar un registro existente.
     */
    ResponseDto update(ID id, RequestDto dto);

    /**
     * Eliminar un registro.
     */
    void delete(ID id);

}
