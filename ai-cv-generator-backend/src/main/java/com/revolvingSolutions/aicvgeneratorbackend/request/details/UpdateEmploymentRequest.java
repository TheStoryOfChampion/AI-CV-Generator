package com.revolvingSolutions.aicvgeneratorbackend.request.details;

import com.revolvingSolutions.aicvgeneratorbackend.model.Employment;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UpdateEmploymentRequest {
    private Employment employment;
}
