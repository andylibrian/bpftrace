; ModuleID = 'bpftrace'
source_filename = "bpftrace"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf-pc-linux"

; Function Attrs: nounwind
declare i64 @llvm.bpf.pseudo(i64, i64) #0

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

define i64 @"kretprobe:vfs_read"(i8* nocapture readnone) local_unnamed_addr section "s_kretprobe:vfs_read_1" {
entry:
  %"@_val" = alloca i64, align 8
  %comm3 = alloca [16 x i8], align 1
  %comm = alloca [16 x i8], align 1
  %1 = getelementptr inbounds [16 x i8], [16 x i8]* %comm, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %1)
  call void @llvm.memset.p0i8.i64(i8* nonnull %1, i8 0, i64 16, i32 1, i1 false)
  %get_comm = call i64 inttoptr (i64 16 to i64 ([16 x i8]*, i64)*)([16 x i8]* nonnull %comm, i64 16)
  %2 = load i8, i8* %1, align 1
  %strcmp.cmp = icmp eq i8 %2, 115
  br i1 %strcmp.cmp, label %strcmp.loop, label %pred_true.critedge

pred_false:                                       ; preds = %strcmp.loop
  ret i64 0

pred_true.critedge:                               ; preds = %entry
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %1)
  br label %pred_true

pred_true:                                        ; preds = %strcmp.loop, %pred_true.critedge
  %3 = getelementptr inbounds [16 x i8], [16 x i8]* %comm3, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %3)
  call void @llvm.memset.p0i8.i64(i8* nonnull %3, i8 0, i64 16, i32 1, i1 false)
  %get_comm4 = call i64 inttoptr (i64 16 to i64 ([16 x i8]*, i64)*)([16 x i8]* nonnull %comm3, i64 16)
  %pseudo = call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %lookup_elem = call i8* inttoptr (i64 1 to i8* (i64, [16 x i8]*)*)(i64 %pseudo, [16 x i8]* nonnull %comm3)
  %map_lookup_cond = icmp eq i8* %lookup_elem, null
  br i1 %map_lookup_cond, label %lookup_merge, label %lookup_success

strcmp.loop:                                      ; preds = %entry
  %4 = getelementptr inbounds [16 x i8], [16 x i8]* %comm, i64 0, i64 1
  %5 = load i8, i8* %4, align 1
  %strcmp.cmp2 = icmp eq i8 %5, 115
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %1)
  br i1 %strcmp.cmp2, label %pred_false, label %pred_true

lookup_success:                                   ; preds = %pred_true
  %cast = bitcast i8* %lookup_elem to i64*
  %6 = load i64, i64* %cast, align 8
  %phitmp = add i64 %6, 1
  br label %lookup_merge

lookup_merge:                                     ; preds = %pred_true, %lookup_success
  %lookup_elem_val.0 = phi i64 [ %phitmp, %lookup_success ], [ 1, %pred_true ]
  %7 = bitcast i64* %"@_val" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %7)
  store i64 %lookup_elem_val.0, i64* %"@_val", align 8
  %pseudo5 = call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %update_elem = call i64 inttoptr (i64 2 to i64 (i64, [16 x i8]*, i64*, i64)*)(i64 %pseudo5, [16 x i8]* nonnull %comm3, i64* nonnull %"@_val", i64 0)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %3)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %7)
  ret i64 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i32, i1) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { nounwind }
attributes #1 = { argmemonly nounwind }
