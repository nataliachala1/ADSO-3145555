package com.sena.cafetinapp.dto.response;

import com.fasterxml.jackson.annotation.JsonView;
import com.sena.cafetinapp.dto.view.JsonViews;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class RolResponseDto {

    @JsonView(JsonViews.Resumen.class)
    private Integer idRol;

    @JsonView(JsonViews.Resumen.class)
    private String name;

    @JsonView(JsonViews.Resumen.class)
    private String description;

}

    // @NotNull        // No puede ser null
    //@NotBlank       // No puede ser null, vacío o solo espacios (String)
    //@NotEmpty       // No puede ser null o vacío (Strings, Collections)
    //@Size(min=, max=)  // Tamaño mínimo/máximo
    //@Min(value)     // Valor mínimo (números)
    //@Max(value)     // Valor máximo (números)
    //@Email          // Debe ser email válido
    //@Pattern(regexp="")  // Debe coincidir con expresión regular
    //@Past           // Fecha en el pasado
    //@Future         // Fecha en el futuro
    //@Positive       // Número positivo
    //@PositiveOrZero // Número positivo o cero
    //@DecimalMin     // Valor decimal mínimo
    //@DecimalMax     // Valor decimal máximo