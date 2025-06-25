package com.customerissue.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import com.customerissue.enums.DifficultyLevel;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.*;
import java.math.BigDecimal;
import java.util.List;

/**
 * 解决方案实体
 * 
 * @author Customer Issue System
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "solutions", autoResultMap = true)
@Schema(description = "解决方案信息")
public class Solution extends BaseEntity {

    @Schema(description = "关联问题ID", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "关联问题ID不能为空")
    @TableField("issue_id")
    private Long issueId;

    @Schema(description = "解决方案标题", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "解决方案标题不能为空")
    @Size(max = 255, message = "解决方案标题长度不能超过255个字符")
    @TableField("title")
    private String title;

    @Schema(description = "解决步骤详情", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "解决步骤详情不能为空")
    @TableField("content")
    private String content;

    @Schema(description = "成功率")
    @DecimalMin(value = "0.00", message = "成功率不能小于0")
    @DecimalMax(value = "100.00", message = "成功率不能大于100")
    @TableField("success_rate")
    private BigDecimal successRate;

    @Schema(description = "平均解决时间(分钟)")
    @Min(value = 0, message = "平均解决时间不能小于0")
    @TableField("avg_time_minutes")
    private Integer avgTimeMinutes;

    @Schema(description = "需要的工具")
    @TableField(value = "tools_required", typeHandler = JacksonTypeHandler.class)
    private List<String> toolsRequired;

    @Schema(description = "难度级别")
    @TableField("difficulty_level")
    private DifficultyLevel difficultyLevel;

    @Schema(description = "使用次数")
    @TableField("usage_count")
    private Integer usageCount;

    @Schema(description = "成功次数")
    @TableField("success_count")
    private Integer successCount;

    @Schema(description = "创建人ID")
    @TableField("created_by")
    private Long createdBy;

    // 扩展字段，不存储到数据库
    @Schema(description = "问题标题")
    @TableField(exist = false)
    private String issueTitle;

    @Schema(description = "创建人名称")
    @TableField(exist = false)
    private String createdByName;

    @Schema(description = "实际成功率")
    @TableField(exist = false)
    private BigDecimal actualSuccessRate;
} 