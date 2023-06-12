package com.revolvingSolutions.aicvgeneratorbackend.request.details.qualification;

import com.revolvingSolutions.aicvgeneratorbackend.model.Qualification;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UpdateQualification {
    private Qualification qualification;
}
