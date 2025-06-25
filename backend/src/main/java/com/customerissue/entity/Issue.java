package com.customerissue.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import com.customerissue.enums.IssuePriority;
import com.customerissue.enums.IssueStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import java.util.List;

/**
 * 问题实体
 * 
 * @author Customer Issue System
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "issues", autoResultMap = true)
@Schema(description = "问题信息")
public class Issue extends BaseEntity {

    @Schema(description = "问题标题", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "问题标题不能为空")
    @Size(max = 255, message = "问题标题长度不能超过255个字符")
    @TableField("title")
    private String title;

    @Schema(description = "问题描述")
    @TableField("description")
    private String description;

    @Schema(description = "分类ID")
    @TableField("category_id")
    private Long categoryId;

    @Schema(description = "标签列表")
    @TableField(value = "tags", typeHandler = JacksonTypeHandler.class)
    private List<String> tags;

    @Schema(description = "相关图片路径")
    @TableField(value = "images", typeHandler = JacksonTypeHandler.class)
    private List<String> images;

    @Schema(description = "优先级")
    @TableField("priority")
    private IssuePriority priority;

    @Schema(description = "状态")
    @TableField("status")
    private IssueStatus status;

    @Schema(description = "向量数据库ID")
    @TableField("vector_id")
    private String vectorId;

    @Schema(description = "查看次数")
    @TableField("view_count")
    private Integer viewCount;

    @Schema(description = "解决方案数量")
    @TableField("solution_count")
    private Integer solutionCount;

    @Schema(description = "创建人ID")
    @TableField("created_by")
    private Long createdBy;

    // 扩展字段，不存储到数据库
    @Schema(description = "分类名称")
    @TableField(exist = false)
    private String categoryName;

    @Schema(description = "创建人名称")
    @TableField(exist = false)
    private String createdByName;

    @Schema(description = "解决方案列表")
    @TableField(exist = false)
    private List<Solution> solutions;
} 